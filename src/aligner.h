/*
 * aligner.h
 *
 *  Created on: 2012/10/05
 *      Author: shu
 */

#ifndef ALIGNER_H_
#define ALIGNER_H_

#include <string>
#include <tr1/memory>
#include <vector>

#include "aligner_common.h"
#include "aligner_presearch_thread.h"
#include "alphabet_coder.h"
#include "database.h"
#include "edit_blocks.h"
#include "queries.h"
#include "score_matrix.h"
#include "sequence_type.h"

class Aligner {
 public:
  typedef AlignerPresearchThread::DatabaseType DatabaseType;
  typedef AlignerCommon::DatabaseCommonParameters<DatabaseType>
      DatabaseParameters;
  typedef AlignerCommon::AligningCommonParameters AligningParameters;
  typedef AlignerCommon::PresearchedResult PresearchedResult;
  typedef AlignerCommon::Result Result;
  Aligner() {}
  virtual ~Aligner() {}

  void BuildDatabase(std::string &input_filename,
                     std::string &database_filename,
                     DatabaseParameters paramters);
  void Align(std::string &queries_filename, std::string &database_filename,
             std::string &output_filename, AligningParameters &parameters);

 private:
  typedef AlignerCommon::AlignmentPositionLessPosition
      AlignmentPositionLessPosition;
  typedef AlignerCommon::PresearchedResultGreaterScore
      PresearchedResultGreaterScore;
  typedef AlignerCommon::ResultGreaterScore ResultGreaterScore;
  typedef AlignerCommon::AlignmentPosition AlignmentPosition;
  typedef AlignerCommon::Coordinate Coordinate;

  void SetQueriesData(Queries &queries, AligningParameters &parameters,
                      std::vector<int> &ungapped_extension_cutoffs,
                      std::vector<int> &gapped_extension_triggers);

  void AddResults(DatabaseType &database, AligningParameters &parameters,
                  std::vector<std::vector<AlignmentPosition> >
                      &alignment_start_positions_in_database,
                  std::vector<PresearchedResult> &added_results,
                  std::vector<PresearchedResult> &results);

  void BuildDatabaseParameters(DatabaseParameters &parameters,
                               DatabaseType::Parameters &database_parameters);
  virtual void Presearch(
      Queries &queries, DatabaseType &database, AligningParameters &parameters,
      std::vector<std::vector<PresearchedResult> > &results_list);

  void BuildResults(
      Queries &queries, DatabaseType &database, AligningParameters &parameters,
      std::vector<std::vector<PresearchedResult> > &presearch_results_list,
      std::vector<std::vector<Result> > &results_list);

  void WriteOutput(std::ostream &os, Queries &queries, DatabaseType &database,
                   AligningParameters &parameters,
                   std::vector<std::vector<Result> > &results);
};

#endif /* ALIGNER_H_ */
